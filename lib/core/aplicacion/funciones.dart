class Funciones {
  static String? validacionText(String nombrecampo, String? value) {
    if (value == null || value.isEmpty) {
      return "El $nombrecampo es obligatorio";
    }
    return null;
  }
}
