import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  Future<void> sendEmailWithAttachment(File file, String recipientEmail) async {
    // Create an SMTP server configuration
    final smtpServer = gmail('mbilalofficial.pk@gmail.com', 'cqepjkxlpaksklds');

    // Create a message
    final message = Message()
      ..from = const Address('mbilalofficial.pk@gmail.com', 'Private Mail')
      ..recipients.add(recipientEmail)
      ..subject = 'Email with Attachment'
      ..text = 'Please see the attached file'
      ..attachments.add(FileAttachment(file));

    // Send the message using the SMTP server
    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      throw Exception('Message not sent. $e');
    }
  }
}
