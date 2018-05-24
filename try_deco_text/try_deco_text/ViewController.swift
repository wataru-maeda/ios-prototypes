//
//  ViewController.swift
//  try_deco_text
//
//  Created by Wataru Maeda on 2018-05-22.
//  Copyright © 2018 com.watarumaeda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var label: UILabel! {
    didSet {
      label.frame = UIScreen.main.bounds
      label.text = "1111<em>2222<em>3333<em>4444<em>"
      label.font = UIFont.systemFont(ofSize: 20)
      label.textAlignment = .center
      label.numberOfLines = 0
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    label = UILabel()
    label.decoText(
      "Baseball was first introduced to Japan in <b>1872<b> and <b>is<b> currently among the country's most popular participatory and spectator sports.",
      backgroundColor: .yellow,
      boldFont: UIFont.boldSystemFont(ofSize: 30)
    )
    view.addSubview(label)
  }
}

extension UILabel {
  
  func decoText(_ text: String, backgroundColor: UIColor, boldFont: UIFont) {
    
    // remove tags
    let textWithoutEm = text.replacingOccurrences(of: "<em>", with: "")
    let textWithoutB = text.replacingOccurrences(of: "<b>", with: "")
    var textWithoutTag = text.replacingOccurrences(of: "<em>", with: "")
    textWithoutTag = textWithoutTag.replacingOccurrences(of: "<b>", with: "")
    
    // devide by em tag
    var emTexts = textWithoutB.components(separatedBy: "<em>")
    var bTexts = textWithoutEm.components(separatedBy: "<b>")
    
    // create attribute text
    let attrText = NSMutableAttributedString(string: textWithoutTag)
    
    // deco <em> texts
    if emTexts.count > 2 {
      
      // remove first/last element
      emTexts.removeFirst()
      emTexts.removeLast()
      
      // deco background color
      for emText in emTexts {
        if let range = textWithoutTag.range(of: emText) {
          let nsRange = textWithoutTag.nsRange(from: range)
          attrText.addAttribute(.backgroundColor, value: backgroundColor, range: nsRange)
        }
      }
    }
    
    // deco <b> tag
    if bTexts.count > 2 {
      
      // remove first/last element
      bTexts.removeFirst()
      bTexts.removeLast()
      
      // deco bold color
      for bText in bTexts {
        if let range = textWithoutTag.range(of: bText) {
          let nsRange = textWithoutTag.nsRange(from: range)
          attrText.addAttribute(.font, value: boldFont, range: nsRange)
        }
      }
    }
    
    attributedText = attrText
  }
}

private extension StringProtocol where Index == String.Index {
  func nsRange(from range: Range<Index>) -> NSRange {
    return NSRange(range, in: self)
  }
}
