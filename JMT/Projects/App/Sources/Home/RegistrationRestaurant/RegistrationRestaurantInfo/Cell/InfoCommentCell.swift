//
//  CommentCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/05.
//

import UIKit

protocol InfoCommentCellDelegate: AnyObject {
    func updateInfoComment(text: String)
}

class InfoCommentCell: UICollectionViewCell {
    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    weak var delegate: InfoCommentCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commentTextView.delegate = self
        
    }
    
    func moveToScroll(section: Int) {
        if let collectionView = self.superview as? UICollectionView {
            collectionView.moveToScroll(section: section, row: 0, margin: 100)
        }
    }
    
    func setupEditData(str: String?) {
        commentTextView.text = str
        commentTextView.textColor = .black
        commentCountLabel.text = "\(str?.count ?? 0)/\(100)"
    }
}
 
extension InfoCommentCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "(필수) 멤버들에게 맛집소개 한마디를 적어주세요" {
            textView.text = nil
            textView.textColor = UIColor.black // 실제 텍스트 입력 시 색상
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "(필수) 멤버들에게 맛집소개 한마디를 적어주세요"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder() // 키보드 숨기기
            moveToScroll(section: 2)
            return false // 텍스트 뷰에 새 줄 추가 방지
        }
        
        // 현재 텍스트 뷰의 텍스트를 NSString 타입으로 변환합니다.
        let currentText = textView.text as NSString
        // 변경 후의 텍스트를 생성합니다.
        let updatedText = currentText.replacingCharacters(in: range, with: text)
        // 변경 후의 텍스트 길이가 maxCharacterLimit을 초과하지 않도록 합니다.
        return updatedText.count <= 100
    }
    
    // 글자 수를 UI에 업데이트하는 메서드
    func updateCharacterCountLabel(with characterCount: Int) {
        commentCountLabel.text = "\(characterCount)/\(100)"
    }
    
    // 텍스트뷰의 텍스트가 변경될 때마다 호출되는 메서드
    func textViewDidChange(_ textView: UITextView) {
        // 텍스트 변경 시 글자 수를 즉시 업데이트합니다.
        let characterCount = textView.text.count
        delegate?.updateInfoComment(text: textView.text)
        updateCharacterCountLabel(with: characterCount)
    }
}

