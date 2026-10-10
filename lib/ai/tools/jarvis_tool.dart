/// Ijozatho, ki toolho metavonand talab kunand (baʼdan istifoda meshavad).
enum ToolPermission { contacts, phone, sms, camera, microphone }

class ToolResult {
  const ToolResult.success(this.message) : success = true;
  const ToolResult.failure(this.message) : success = false;

  final bool success;
  final String message;
}

/// Har tool alohida va permission-aware ast.
abstract interface class JarvisTool {
  String get name;
  String get description;
  Set<ToolPermission> get requiredPermissions;

  Future<ToolResult> execute(Map<String, Object?> args);
}

/// Tekshiri ijozat. Baʼdan ba Android permission-ho pajvand meshavad.
abstract interface class PermissionGate {
  Future<bool> isGranted(Set<ToolPermission> permissions);
}

/// Hozir faqat toolhoi bo ijozatnoki ruxsat dorad.
class NoPermissionsGate implements PermissionGate {
  const NoPermissionsGate();

  @override
  Future<bool> isGranted(Set<ToolPermission> permissions) async =>
      permissions.isEmpty;
}

class ToolRegistry {
  ToolRegistry(Iterable<JarvisTool> tools)
      : _tools = {for (final tool in tools) tool.name: tool};

  final Map<String, JarvisTool> _tools;

  JarvisTool? find(String name) => _tools[name];

  List<JarvisTool> get all => List.unmodifiable(_tools.values);
}
