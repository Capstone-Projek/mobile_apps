enum MyWorkmanager {
  periodic("task-identifier", "task-identifier");

  final String uniqueName;
  final String taskName;

  const MyWorkmanager(this.uniqueName, this.taskName);
}
