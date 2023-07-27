final jours = [
  "Lundi",
  "Lundi",
  "Mardi",
  "Mercredi",
  "Jeudi",
  "Vendredi",
  "Samedi",
  "Dimanche"
];

final mois = [
  "Jan",
  "Jan",
  "Fev",
  "Mars",
  "Avril",
  "Mai",
  "Juin",
  "Juil",
  "Aout",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

class BreakDate {
  // Date à la Franchouille en Input
  // Date Normalisé + Year Month
  var theYear;
  var theMonth;
  var theDay;
  String brutDate;

  DateTime checkDate = DateTime(2023, 07, 26);
  BreakDate(this.brutDate) {
    List deCoupe = this.brutDate.split('/');

    this.theDay = int.parse(deCoupe[0]);
    this.theMonth = int.parse(deCoupe[1]);
    this.theYear = int.parse(deCoupe[2]);
    this.checkDate = DateTime(this.theYear, this.theMonth, this.theDay);
  }
}

class ConfigTchinos {
//
// Date Normalisé + Year Month
  var theYear;
  var theMonth;
  var theDay;
  String brutDate="";
  DateTime checkDate= DateTime(2023, 07, 26);


}
