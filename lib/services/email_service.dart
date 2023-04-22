import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  Future<void> sendEmailWithAttachment(File file, String recipientEmail) async {
    final smtpServer =
        gmail('mailnotifications@wallstreetmailboxes.com', 'cfqejlgjchakopra');

    final message = Message()
      ..from = const Address(
          'mailnotifications@wallstreetmailboxes.com', 'Wall Street Mailboxes')
      ..recipients.add(recipientEmail)
      ..subject = 'Attachment from Wall Street Mailboxes'
      ..text = 'Please see the attached file'
      ..attachments.add(FileAttachment(file));

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      throw Exception('Message not sent. $e');
    }
  }
}
