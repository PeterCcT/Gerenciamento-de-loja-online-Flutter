class ProdutoValidator {
  String validateTitle(String text) {
    if (text.isEmpty) return "Preencha o título do produto";
    return null;
  }

  String validateDescription(String text) {
    if (text.isEmpty) return "Preencha a descrição do produto";
    return null;
  }

  String validatePreco(String text) {
    double preco = double.tryParse(text);
    if (preco != null) {
      if (!text.contains(".") || text.split(".")[1].length != 2)
        return "Utilize 2 cassa decimais";
    } else {
      return "Preço inválido";
    }
    return null;
  }

  String validadeteImages(List images) {
    if (images.isEmpty) return "Adicione uma imagem";
    return null;
  }

  String validateTamanho(List tamanhos) {
    if (tamanhos.isEmpty) return "Adicione ao menos um tamanho";
    return null;
  }
}
