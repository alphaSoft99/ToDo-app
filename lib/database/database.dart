// don't import moor_web.dart or moor_flutter/moor_flutter.dart in shared code
import 'package:moor/moor.dart';

part 'database.g.dart';

@DataClassName('TodoEntry')
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get content => text()();

  DateTimeColumn get targetDate => dateTime().nullable()();

  IntColumn get category => integer()
      .nullable()
      .customConstraint('NULLABLE REFERENCES categories(id)')();

  BoolColumn get notification => boolean().named('notification')();

  BoolColumn get done => boolean().named('done')();
}

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get description => text().named('desc')();
}

class CategoryWithCount {
  CategoryWithCount(this.category, this.count);

  // can be null, in which case we count how many entries don't have a category
  final Category category;
  final int count; // amount of entries in this category
}

class EntryWithCategory {
  EntryWithCategory(this.entry, this.category);

  final TodoEntry entry;
  final Category category;
}

@UseMoor(
  tables: [Todos, Categories],
  queries: {
    '_resetCategory': 'UPDATE todos SET category = NULL WHERE category = ?',
  },
)
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        // ignore: deprecated_member_use
        return m.createAllTables();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          await m.addColumn(todos, todos.targetDate);
        }
      },
      beforeOpen: (details) async {
        if (details.wasCreated) {
          // create default categories and entries
          await into(categories).insert(
              const CategoriesCompanion(
                  description: Value('personal'), id: Value(0)));
          await into(categories).insert(
              const CategoriesCompanion(
                  description: Value('work'), id: Value(1)));
          await into(categories).insert(
              const CategoriesCompanion(
                  description: Value('meeting'), id: Value(2)));
          await into(categories).insert(
              const CategoriesCompanion(
                  description: Value('shopping'), id: Value(3)));
          await into(categories).insert(
              const CategoriesCompanion(
                  description: Value('party'), id: Value(4)));
          await into(categories).insert(
              const CategoriesCompanion(
                  description: Value('study'), id: Value(5)));
          //TODO setExample
          /*await into(todos).insert(TodosCompanion(
            category: Value(1),
            content: const Value('A first todo entry'),
            notification: const Value(false),
            done: const Value(false),
            targetDate: Value(
                DateTime.now().add(Duration(days: 10))
            ),
          ));

          await into(todos).insert(
            TodosCompanion(
              content: const Value('Rework persistence code'),
              category: Value(0),
              notification: const Value(false),
              done: const Value(false),
              targetDate: Value(
                  DateTime.now()
              ),
              ),
          );*/
        }
      },
    );
  }

  Stream<List<CategoryWithCount>> categoriesWithCount() {
    // select all categories and load how many associated entries there are for
    // each category
    // ignore: deprecated_member_use
    return customSelectQuery(
      'SELECT c.id, c.desc, '
      '(SELECT COUNT(*) FROM todos WHERE category = c.id ) AS amount '
      'FROM categories c '
      'UNION ALL SELECT null, null, '
      '(SELECT COUNT(*) FROM todos WHERE category IS NULL)',
      readsFrom: {todos, categories},
    ).map((row) {
      // when we have the result set, map each row to the data class
      final hasId = row.data['id'] != null;

      return CategoryWithCount(
        hasId ? Category.fromData(row.data, this) : null,
        row.readInt('amount'),
      );
    }).watch();
  }

  /// Watches all entries in the given [category]. If the category is null, all
  /// entries will be shown instead.
  Stream<List<EntryWithCategory>> watchEntriesInCategory(Category category) {
    final query = select(todos).join(
        [leftOuterJoin(categories, categories.id.equalsExp(todos.category))]);

    if (category != null) {
      query.where(categories.id.equals(category.id));
    } else {
      query.where(isNull(categories.id));
    }

    return query.watch().map((rows) {
      // read both the entry and the associated category for each row
      return rows.map((row) {
        return EntryWithCategory(
          row.readTable(todos),
          row.readTable(categories),
        );
      }).toList();
    });
  }

  Stream<List<TodoEntry>> watchEntries(DateTime dateTime) {
    final query1 = select(todos);
    query1.where((tbl) => tbl.targetDate.isBiggerOrEqualValue(dateTime));
    query1.orderBy([(t) => OrderingTerm(expression: t.targetDate)]);
    return query1.watch();
  }

  Stream<List<TodoEntry>> notificationEntries(DateTime dateTime) {
    final query = select(todos);
    query.where(
        (tbl) => tbl.targetDate.isBiggerOrEqualValue(dateTime));
    query.where(
        (tbl) => tbl.targetDate.day.equals(dateTime.day));
    query.where((tbl) => tbl.notification.equals(true));
    query.where((tbl) => tbl.done.equals(false));
    query.orderBy([(t) => OrderingTerm(expression: t.targetDate)]);
    query.limit(1);
    /*query.watchSingle().firstWhere((element) => element != null,
            orElse: () => TodoEntry(
                id: 0,
                content: "",
                notification: false,
                category: 0,
                done: false,
                targetDate: DateTime.now()))
        .then((value) {
      return Stream.value(value);
    });*/
    return query.watch();
  }

  Stream<List<TodoEntry>> todayTasksCount(DateTime dateTime) {
    final query = select(todos);
    query.where((tbl) => tbl.targetDate.year.equals(dateTime.year));
    query.where((tbl) => tbl.targetDate.month.equals(dateTime.month));
    query.where((tbl) => tbl.targetDate.day.equals(dateTime.day));
    return query.watch();
  }

  Stream<List<Category>> getCategory(){
    final query = select(categories);
    query.limit(6);
    return query.watch();
  }

  Future<List<TodoEntry>> getEntry(DateTime dateTime) async {
    final query = select(todos);
    query.where(
            (tbl) => tbl.targetDate.equals(dateTime));
    query.where((tbl) => tbl.notification.equals(true));
    query.where((tbl) => tbl.done.equals(false));
    query.orderBy([(t) => OrderingTerm(expression: t.targetDate)]);
    return query.get();
  }

  Future createEntry(TodosCompanion entry) {
    return into(todos).insert(entry);
  }

  /// Updates the row in the database represents this entry by writing the
  /// updated data.
  Future updateEntry(TodoEntry entry) {
    return update(todos).replace(entry);
  }

  Future deleteEntry(TodoEntry entry) {
    return delete(todos).delete(entry);
  }

  Future<int> createCategory(String description) {
    return into(categories)
        .insert(CategoriesCompanion(description: Value(description)));
  }

  Future deleteCategory(Category category) {
    return transaction(() async {
      await _resetCategory(category.id);
      await delete(categories).delete(category);
    });
  }
}

Value<T> addField<T>(T val, {T fallback}) {
  Value<T> _fallback;
  if (fallback != null) {
    _fallback = Value<T>(fallback);
  }
  if (val == null) {
    return _fallback ?? Value.absent();
  }
  if (val is String && (val == 'null' || val == 'Null')) {
    return _fallback ?? Value.absent();
  }
  return Value(val);
}
