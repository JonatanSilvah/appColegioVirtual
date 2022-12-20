class ModelTurma {
  String? _nome;
  String? _anoTurma;
  String? _cidade;
  String? _idTurma;
  String? _anoFinal;

  String get anoFinal => _anoFinal!;
  set anoFinal(String value) {
    _anoFinal = value;
  }

  String get idTurma => _idTurma!;
  set idTumra(String value) {
    _idTurma = value;
  }

  String get nome => _nome!;
  set nome(String value) {
    _nome = value;
  }

  String get anoTurma => _anoTurma!;
  set anoTurma(String value) {
    _anoTurma = value;
  }

  String get cidade => _cidade!;
  set cidade(String value) {
    _cidade = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this.nome,
      "anoInicio": this.anoTurma,
      "cidade": this.cidade,
      "anoFinal": this.anoFinal
    };
    return map;
  }
}
