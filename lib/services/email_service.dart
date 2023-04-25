import 'dart:io';

import 'package:mail_processor/main.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  Future<void> sendEmailWithAttachment(File file, String recipientEmail) async {
    final email = sp.getString('controller0')!;
    final password = sp.getString('controller1')!;
    final subject =
        sp.getString('controller2') ?? 'Attachment from Wall Street Mailboxes';
    final text = sp.getString('controller3') ?? 'Please see attachment';

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
