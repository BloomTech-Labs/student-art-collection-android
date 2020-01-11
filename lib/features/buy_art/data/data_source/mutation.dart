const String SUBMIT_CONTACT_FORM_MUTATION = r'''
  mutation submitContactForm(
    $sendto: String,
    $subject: String,
    $fromUser: String,
    $message: String,
    $name: String) {
      action: sendMail(
        sendto: $sendto, 
        subject: $subject,
        fromUser: $fromUser,
        message: $message,
        name: $name
      ) {
        sendto,
        subject,
        fromUser,
        message,
        name
      }
    }
''';