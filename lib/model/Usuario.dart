class Usuario {
  String? _nome;
  String? _email;
  String? _senha;
  String? _dataNasc;
  String? _idUsuario;
  String? _cpfUsuario;
  String? _celularUsuario;
  String? _cidadeUsuario;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this.nome,
      "email": this.email,
      "idUsuario": this.idUsuario,
      "dataNasc": this.dataNasc,
      "cpf": this.cpfUsuario,
      "celular": this.celularUsuario,
      "cidade": this.cidadeUsuario,
      "tipoUsuario": "aluno"
    };
    return map;
  }

  String get cidadeUsuario => _cidadeUsuario!;
  set cidadeUsuario(String value) {
    _cidadeUsuario = value;
  }

  String get celularUsuario => _celularUsuario!;
  set celularUsuario(String value) {
    _celularUsuario = value;
  }

  String get cpfUsuario => _cpfUsuario!;
  set cpfUsuario(String value) {
    _cpfUsuario = value;
  }

  String get dataNasc => _dataNasc!;
  set dataNasc(String value) {
    _dataNasc = value;
  }

  String get idUsuario => _idUsuario!;
  set idUsuario(String value) {
    _idUsuario = value;
  }

  String get senha => _senha!;
  set senha(String value) {
    _senha = value;
  }

  String get nome => _nome!;
  set nome(String value) {
    _nome = value;
  }

  String get email => _email!;
  set email(String value) {
    _email = value;
  }
}
