String createFullUpc(String upc) {
  var upcZeroes = 13;
  final upcLength = upc.length;
  final zeroesToAdd = upcZeroes - upcLength;
  String createdUpc = '';
  for (var i = 0; i < zeroesToAdd; i++) {
    createdUpc = createdUpc + '0';
  }
  createdUpc = createdUpc + upc;
  return createdUpc;
}
