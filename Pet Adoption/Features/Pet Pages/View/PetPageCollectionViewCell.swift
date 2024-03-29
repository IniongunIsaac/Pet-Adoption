//
//  PetPageCollectionViewCell.swift
//  Pet Adoption
//
//  Created by Isaac Iniongun on 12/11/2019.
//  Copyright © 2019 InGroups. All rights reserved.
//

import UIKit
import Entities
import DatePicker
import Kingfisher
import MBCheckboxButton

class PetPageCollectionViewCell: UICollectionViewCell, CheckboxButtonDelegate {
    
    private let parentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let parentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let sectionTitleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var currentRules = [Rule?]()
    
    var page: Page? {
        didSet {
            guard let pg = page else { return }
            
            setPageTitle(title: pg.label)
            
            pg.sections.forEach { sect in
                addSectionToPage(section: sect)
            }
            
        }
    }
    
    var elementsStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        addSubview(parentScrollView)
        parentScrollView.addSubview(parentView)
        
        NSLayoutConstraint.activate([
            
            parentScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            parentScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            parentScrollView.topAnchor.constraint(equalTo: topAnchor),
            parentScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            parentView.leadingAnchor.constraint(equalTo: parentScrollView.leadingAnchor, constant: 20),
            parentView.trailingAnchor.constraint(equalTo: parentScrollView.trailingAnchor, constant: 20),
            parentView.topAnchor.constraint(equalTo: parentScrollView.topAnchor),
            parentView.bottomAnchor.constraint(equalTo: parentScrollView.bottomAnchor),
            //parentView.heightAnchor.constraint(equalTo: heightAnchor),
            //parentView.widthAnchor.constraint(equalTo: widthAnchor)
            
        ])
    }
    
    fileprivate func setPageTitle(title: String) {
        
        pageTitleLabel.attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black])
        parentView.addSubview(pageTitleLabel)
        
        NSLayoutConstraint.activate([
            pageTitleLabel.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 10),
            pageTitleLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            pageTitleLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        ])
    }
    
    fileprivate func addSectionToPage(section: Section) {
        
        let sectionLabel = UILabel()
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionLabel.text = section.label
        sectionLabel.textColor = .black
        
        var elementsArray = [UIView]()
        elementsArray.append(sectionLabel)
        
        section.elements.forEach { element in
            elementsArray.append(getSectionElement(element: element))
            element.rules.forEach { rule in
                currentRules.append(rule)
            }
        }
        
        elementsStackView.translatesAutoresizingMaskIntoConstraints = false
        elementsStackView.distribution = .fill
        elementsStackView.axis = .vertical
        elementsStackView.spacing = 20
        elementsStackView.alignment = .leading
        
        parentView.addSubview(elementsStackView)
        
        elementsArray.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            elementsStackView.addArrangedSubview(view)
        }
        
        NSLayoutConstraint.activate([
            elementsStackView.topAnchor.constraint(equalTo: pageTitleLabel.bottomAnchor, constant: 10),
            elementsStackView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            elementsStackView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            elementsStackView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -10)
            
        ])

    }
    
    fileprivate func getSectionElement(element: Element) -> UIView {
        
        var view: UIView!
        
        if let elementType = element.type {
            
            switch elementType {
                
            case Constants.photoElementType:
                view = getEmbeddedPhotoImageView(element: element)
                
            case Constants.textElementType:
                view = getTextField(element: element)
                
            case Constants.yesNoElementType:
                view = getYesNoCheckbox(element: element)
                
            case Constants.dateElementType:
                view = getDateButton(element: element)
                
            case Constants.numericElementType:
                view = getNumberTextField(element: element)
                
            default:
                print("Invalid element type.")
            }
            
        }
        
        return view
    }
    
    fileprivate func getEmbeddedPhotoImageView(element: Element) -> UIImageView {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        if let imageUrl = element.file {
            setImage(imageView: imageView, imageUrl: imageUrl)
        }
        imageView.accessibilityIdentifier = element.uniqueId
        
        return imageView
    }
    
    fileprivate func getTextField(element: Element) -> UITextField {
        
        let textField = UITextField()
        textField.accessibilityIdentifier = element.uniqueId
        textField.attributedPlaceholder = NSMutableAttributedString(string: element.label ?? "Enter text here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        textField.bounds.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        
        if let emailType = element.label {
            if emailType.caseInsensitiveCompare("Email address") == .orderedSame {
                textField.textContentType = .emailAddress
            }
        }
        
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalToConstant: frame.width - 40),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        return textField
    }
    
    fileprivate func getNumberTextField(element: Element) -> UITextField {
        
        let numberTextField = UITextField()
        numberTextField.attributedPlaceholder = NSMutableAttributedString(string: element.label ?? "Enter number here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        numberTextField.accessibilityIdentifier = element.uniqueId
        numberTextField.textContentType = .telephoneNumber
        numberTextField.keyboardType = .numberPad
        numberTextField.bounds.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        numberTextField.layer.borderWidth = 1
        numberTextField.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        
        NSLayoutConstraint.activate([
            numberTextField.widthAnchor.constraint(equalToConstant: frame.width - 40),
            numberTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        return numberTextField
    }
    
    fileprivate func getDateButton(element: Element) -> UIButton {
        
        let dateButton = UIButton()
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        dateButton.setTitle(element.label ?? "Choose Date", for: .normal)
        dateButton.accessibilityIdentifier = element.uniqueId
        dateButton.setTitleColor(.white, for: .normal)
        dateButton.backgroundColor = .mainColor
        dateButton.addTarget(self, action: #selector(displayDatePickerDialog(button:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            dateButton.heightAnchor.constraint(equalToConstant: 45),
            dateButton.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        return dateButton
    }
    
    fileprivate func getYesNoCheckbox(element: Element) -> CheckboxButton {
        let yesNoCheckbox = CheckboxButton()
        
        yesNoCheckbox.accessibilityIdentifier = element.uniqueId
        let checkboxTitle = NSMutableAttributedString(string: element.label ?? "Choose here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        yesNoCheckbox.setAttributedTitle(checkboxTitle, for: .normal)
        yesNoCheckbox.setTitle(element.label, for: .normal)
        yesNoCheckbox.checkBoxColor = CheckBoxColor(activeColor: .mainColor, inactiveColor: .gray, inactiveBorderColor: .darkGray, checkMarkColor: .mainColor)
        yesNoCheckbox.delegate = self
        
        return yesNoCheckbox
    }
    
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        
        currentRules.forEach { rule in
            if let rl = rule {
                if !rl.targets.isEmpty {
                    
                    rl.targets.forEach { target in
                        parentView.subviews.filter { vw -> Bool in
                        vw.accessibilityIdentifier?.caseInsensitiveCompare(target) == .orderedSame
                        }.forEach { vw in
                            if rl.action.caseInsensitiveCompare("show") == .orderedSame {
                                vw.alpha = 0
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
        currentRules.forEach { rule in
            if let rl = rule {
                if !rl.targets.isEmpty {
                    
                    rl.targets.forEach { target in
                        parentView.subviews.filter { vw -> Bool in
                            vw.accessibilityIdentifier?.caseInsensitiveCompare(target) == .orderedSame
                        }.forEach { vw in
                            if rl.action.caseInsensitiveCompare("show") == .orderedSame {
                                vw.alpha = 1
                            }
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func setImage(imageView: UIImageView, imageUrl: String) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: URL(string: imageUrl),
            placeholder: UIImage(named: "placeholder_image"),
            options: [.transition(.fade(0.2))]
        )
    }
    
    @objc fileprivate func displayDatePickerDialog(button: UIButton) {
        
        let datePicker = DatePicker()
        
        datePicker.setup(min: Date.from()!, max: Date()) { (selected, date) in
            
            //If the user hits the `Select` on the DatePicker Dialog
            if selected {
                /*  The Date returned by the DatePicker Library is in the format: 1999-12-31 23:00:00 +0000.
                 the goal here is to extract 1999-12-31 from the returned date
                 */
                let dateOnlyString = date?.description.components(separatedBy: " ")[0]
                
                //From the extracted 1999-12-31, we make an array [1999, 12, 31] for Year, Month and Day
                let dateOnlyStringArray = dateOnlyString!.components(separatedBy: "-")
                
                //From the above array, We get a Date using the Year, Month and Day elements of the array
                let dateUsingDateOnlyString = Date.from(year: Int(dateOnlyStringArray[0])!, month: Int(dateOnlyStringArray[1])!, day: Int(dateOnlyStringArray[2])!)
                
                /*  We add 2 days to the Date obtained above to get the correct date because the DatePicker Library gives us a date
                 that is 2days earlier than our selected date.
                 */
                let correctDate = Calendar.current.date(byAdding: .day, value: 2, to: dateUsingDateOnlyString!)
                
                //We display the correct date as the title of the current Date Button
                let correctDateString: String = (correctDate?.description.components(separatedBy: " ")[0])!
                
                button.setTitle(correctDateString, for: .normal)
                
            }
            
        }
        
        datePicker.colors(main: .mainColor, background: .milkColor, inactive: .gray)
        
        datePicker.display(in: parentViewController!)
    }
}
