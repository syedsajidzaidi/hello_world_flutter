class GithubUser {
  final int id;
  final String login;
  final String avatarUrl;
  final String htmlUrl;

  const GithubUser({
    required this.id,
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
  });

  factory GithubUser.fromJson(Map<String, dynamic> json) => GithubUser(
        id: json['id'] as int,
        login: json['login'] as String,
        avatarUrl: json['avatar_url'] as String,
        htmlUrl: json['html_url'] as String,
      );

  GithubUser copyWith({
    int? id,
    String? login,
    String? avatarUrl,
    String? htmlUrl,
  }) =>
      GithubUser(
        id: id ?? this.id,
        login: login ?? this.login,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        htmlUrl: htmlUrl ?? this.htmlUrl,
      );
}
