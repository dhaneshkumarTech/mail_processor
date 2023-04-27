import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  Future<void> sendEmailWithAttachment(File file, String email, String password,
      String subject, String text, String recipientEmail) async {
    final smtpServer = gmail(email, password);

    final message = Message()
      ..from = Address(email, 'Wall Street Mailboxes')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..text = text
      ..attachments.add(FileAttachment(file));

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      throw Exception('Message not sent. $e');
    }
  }
}
