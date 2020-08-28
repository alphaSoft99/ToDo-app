import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo/database/database/mobile.dart';
import '../database/database.dart';

/// Class that keeps information about a category and whether it's selected at
/// the moment.
class CategoryWithActiveInfo {
  CategoryWithCount categoryWithCount;
  bool isActive;

  CategoryWithActiveInfo(this.categoryWithCount, this.isActive);
}

class NotificationDataWithTasksCount {
  List<TodoEntry> todoEntry;
  List<TodoEntry> tasks;
  List<Category> categories;
  NotificationDataWithTasksCount(this.todoEntry, this.tasks, this.categories);
}

class TodoAppBloc {
  final Database db;
  final dateTimeNow = DateTime.now();
  // the category that is selected at the moment. null means that we show all
  // entries
  final BehaviorSubject<Category> _activeCategory =
      BehaviorSubject.seeded(null);

  Observable<List<EntryWithCategory>> _currentEntries;

  Stream<List<TodoEntry>> _homeEntries;

  /// A stream of entries that should be displayed on the home screen.
  Stream<List<TodoEntry>> get homeScreenEntries => _homeEntries;

  Observable<List<EntryWithCategory>> get taskScreenEntries => _currentEntries;

  final BehaviorSubject<List<CategoryWithActiveInfo>> _allCategories = BehaviorSubject();

  Observable<List<CategoryWithActiveInfo>> get categories => _allCategories;

  // ignore: close_sinks
  final BehaviorSubject<NotificationDataWithTasksCount> _mainData =  BehaviorSubject();

  Observable<NotificationDataWithTasksCount> get mainData => _mainData;

  TodoAppBloc() : db = constructDb(logStatements: true) {
    // listen for the category to change. Then display all entries that are in
    // the current category on the home screen.
    _currentEntries = _activeCategory.switchMap(db.watchEntriesInCategory);

    _homeEntries = db.watchEntries(DateTime(dateTimeNow.year, dateTimeNow.month, dateTimeNow.day, 0, 0));

//    _mainEntries = db.notificationEntries(dateTimeNow);

    // also watch all categories so that they can be displayed in the navigation
    // drawer.
    Observable.combineLatest2<List<CategoryWithCount>, Category,
        List<CategoryWithActiveInfo>>(
      db.categoriesWithCount(),
      _activeCategory,
      (allCategories, selected) {
        return allCategories.map((category) {
          final isActive = selected?.id == category.category?.id;
          return CategoryWithActiveInfo(category, isActive);
        }).toList();
      },
    ).listen(_allCategories.add);

    Observable.combineLatest3<List<TodoEntry>, List<TodoEntry>, List<Category>,
        NotificationDataWithTasksCount>(
      db.notificationEntries(dateTimeNow),
      db.todayTasksCount(dateTimeNow),
      db.getCategory(),
      (todoEntry, tasks, categories) {
        return NotificationDataWithTasksCount(todoEntry, tasks, categories);
      },
    ).listen(_mainData.add);
  }

  void showCategory(Category category) {
    _activeCategory.add(category);
  }

  void addCategory(String description) async {
    final id = await db.createCategory(description);

    showCategory(Category(id: id, description: description));
  }

  void createEntry(TodoEntry todoEntry) {
    db.createEntry(TodosCompanion(
      content: Value(todoEntry.content),
      category: Value(todoEntry.category),
      targetDate: Value(todoEntry.targetDate),
      done: Value(todoEntry.done),
      notification: Value(todoEntry.notification)
    ));
  }

  void updateEntry(TodoEntry entry) {
    db.updateEntry(entry);
  }

  void deleteEntry(TodoEntry entry) {
    db.deleteEntry(entry);
  }

  void deleteCategory(Category category) {
    // if the category being deleted is the one selected, reset that state by
    // showing the entries who aren't in any category
    if (_activeCategory.value?.id == category.id) {
      showCategory(null);
    }
    db.deleteCategory(category);
  }

  void dispose() async {
    await db.close();
    _allCategories.close();
    _activeCategory.close();
  }
}
