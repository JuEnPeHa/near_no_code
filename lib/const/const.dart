class RustConst {}

//This is for the common structs
String getStruct({
  required String name,
  required List<String> fields,
  required List<String> types,
  bool deriveBorshDeserialize = true,
  bool deriveBorshSerialize = true,
  bool deriveSerialize = false,
  bool deriveDeserialize = false,
  bool deriveDebug = false,
  bool deriveClone = false,
  bool derivePartialEq = false,
  bool pub = true,
}) {
  final pubStr = pub ? 'pub ' : '';
  final fieldsStr = fields
      .map((field) => '    ${pubStr + field}: ${types[fields.indexOf(field)]}')
      .join(', \n');
  final deriveStr = [
    deriveBorshDeserialize ? 'BorshDeserialize' : '',
    deriveBorshSerialize ? 'BorshSerialize' : '',
    deriveSerialize ? 'Serialize' : '',
    deriveDeserialize ? 'Deserialize' : '',
    deriveDebug ? 'Debug' : '',
    deriveClone ? 'Clone' : '',
    derivePartialEq ? 'PartialEq' : '',
  ].where((str) => str.isNotEmpty).join(', ');
  final deriveStr2 = deriveStr.isNotEmpty ? '#[derive($deriveStr)]' : '';
  final deriveStr3 = deriveSerialize || deriveDeserialize
      ? '#[serde(crate = "near_sdk::serde")]'
      : '';
  StringBuffer sb = StringBuffer();
  deriveStr2 == "" ? null : sb.writeln(deriveStr2);
  deriveStr3 == "" ? null : sb.writeln(deriveStr3);
  sb.writeln("$pubStr struct $name {");
  sb.writeln(fieldsStr);
  sb.writeln('}');
  return sb.toString();
}

//This is for the main struct (Contract)
String getContractStruct({
  String name = "Contract",
  required List<String> fields,
  required List<String> types,
  bool derivePanicOnDefault = true,
}) {
  const bool deriveBorshDeserialize = true;
  const bool deriveBorshSerialize = true;
  const bool pub = true;
  const pubStr = pub ? 'pub ' : '';
  final lastPartOfTheCode = getStruct(
      name: name,
      fields: fields,
      types: types,
      deriveBorshDeserialize: false,
      deriveBorshSerialize: false);
  final deriveStr = [
    deriveBorshDeserialize ? 'BorshDeserialize' : '',
    deriveBorshSerialize ? 'BorshSerialize' : '',
    derivePanicOnDefault ? 'PanicOnDefault' : 'Default',
  ].where((str) => str.isNotEmpty).join(', ');
  final deriveStr2 = deriveStr.isNotEmpty ? '#[derive($deriveStr)]' : '';
  StringBuffer sb = StringBuffer();
  sb.writeln(deriveStr2);
  sb.writeln(lastPartOfTheCode);
  return sb.toString();
}
