enum Error : ErrorType {
    case QuietError(String)
    case NonFatal(String)
}

func showErrorDialogWithMessage(message: String, inViewController: UIViewController) {
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    inViewController.presentViewController(alert, animated: true, completion: nil)
}
