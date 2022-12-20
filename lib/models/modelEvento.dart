class ModelEvento {
  String? _nomeEvento;
  String? _cidadeEvento;
  String? _turmaEvento;
  String? _dataInicial;
  String? _dataFinal;
  String? _descricao;
  String _status = "Aguardando ínicio";

  String get nomeEvento => _nomeEvento!;
  set nomeEvento(String value) {
    _nomeEvento = value;
  }

  String get status => _status!;
  set status(String value) {
    _status = value;
  }

  String get cidadeEvento => _cidadeEvento!;
  set cidadeEvento(String value) {
    _cidadeEvento = value;
  }

  String get turmaEvento => _turmaEvento!;
  set turmaEvento(String value) {
    _turmaEvento = value;
  }

  String get dataInicial => _dataInicial!;
  set dataInicial(String value) {
    _dataInicial = value;
  }

  String get dataFinal => _dataFinal!;
  set dataFinal(String value) {
    _dataFinal = value;
  }

  String get descricao => _descricao!;
  set descricao(String value) {
    _descricao = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this.nomeEvento,
      "dataInicial": this.dataInicial,
      "dataFinal": this.dataFinal,
      "cidade": this.cidadeEvento,
      "turma": this.turmaEvento,
      "descricao": this.descricao,
      "status": this.status
    };
    return map;
  }
}
