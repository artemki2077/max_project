import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


String host = 'pidorlist.ru';

final form = NumberFormat("#,##0.00", "en_US");

Color maindark = const Color(0xFF121212);
Color dark = const Color(0xFF1D1D1D);
Color primColor = const Color(0xff5B04BC); 

// ['card', 'processor', 'motherboard', 'RAM', 'power', 'memory', ]
var types = {
  'card': 'Видеокарта',
  'processor': 'Процессор',
  'motherboard': 'материская карта',
  'RAM': 'Оперативка',
  'power': 'Блок питания',
  'memory': 'Память',
};