class Language {
  String code;
  String icon;
  String name;
  Language({required this.code, required this.icon, required this.name});
  static final Language english =
      Language(code: 'en', icon: '🇺🇸', name: 'English');
  static final Language vietNamese =
      Language(code: 'vi', icon: '🇻🇳', name: 'Việt Nam');
  static List<Language> languageList() => [
        english,
        vietNamese,
      ];

  Map<String, dynamic> toJson() => {
        'code': code,
        'icon': icon,
        'name': name,
      };

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        code: json['code'],
        icon: json['icon'],
        name: json['name'],
      );
}
