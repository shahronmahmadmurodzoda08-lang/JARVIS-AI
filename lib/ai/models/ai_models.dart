/// Darkhosti ijroi tool: nom + argumentho.
class ToolCall {
  const ToolCall(this.name, [this.args = const <String, Object?>{}]);

  final String name;
  final Map<String, Object?> args;
}

/// Javobi JARVIS ba korbar.
class AgentReply {
  const AgentReply(this.text, {this.isAction = false});

  final String text;

  /// true, agar amal (tool) ijro shuda boshad; false, agar suhbat boshad.
  final bool isAction;
}
