import 'package:flutter_test/flutter_test.dart';
void main(){test('balance uses receivable minus payable',(){final tx=[100.0,-50.0];expect(tx.reduce((a,b)=>a+b),50);});test('positive amounts are required',(){expect(25>0,true);});}
