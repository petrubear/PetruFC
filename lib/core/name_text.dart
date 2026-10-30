/// Los nombres de personas llevan "nombre・apellido": se muestran en dos lineas.
String nameLines(String s) => s.replaceAll('・', '・\n');

/// Para los juegos de letras (sopa, arma la palabra) basta el apellido, que cabe en el tablero.
String surname(String s) => s.contains('・') ? s.split('・').last : s;
