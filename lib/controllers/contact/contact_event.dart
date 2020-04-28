import '../../models/models.dart';

abstract class ContactEvent {}

class SelectContact extends ContactEvent {
  SelectContact(this.contact);
  final Contact contact;
}
