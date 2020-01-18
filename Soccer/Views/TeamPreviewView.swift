//
//  TeamPreviewView.swift
//  Soccer
//
//  Created by Ma Xueyuan on 2020/01/18.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

class TeamPreviewView: UIView {
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    @IBOutlet var label4: UILabel!
    @IBOutlet var label5: UILabel!
    @IBOutlet var label6: UILabel!
    @IBOutlet var label7: UILabel!
    @IBOutlet var label8: UILabel!
    @IBOutlet var label9: UILabel!
    
    let nibName = "TeamPreviewView"
    var team: Team?
    var reverted: Bool?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.borderWidth = 1
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func setPreview() {
        guard let reverted = reverted else {return}
        guard let team = team else {return}
        
        // set border
        if reverted {
            label2.layer.borderColor = UIColor.label.cgColor
            label2.layer.borderWidth = 1
        } else {
            label8.layer.borderColor = UIColor.label.cgColor
            label8.layer.borderWidth = 1
        }
        
        // set label
        if reverted {
            label9.text = "\(team.abilities[0].off)"
            label8.text = "\(team.abilities[1].off)"
            label7.text = "\(team.abilities[2].off)"
            label6.text = "\(team.abilities[0].org)"
            label5.text = "\(team.abilities[1].org)"
            label4.text = "\(team.abilities[2].org)"
            label3.text = "\(team.abilities[0].def)"
            label2.text = "\(team.abilities[1].def)"
            label1.text = "\(team.abilities[2].def)"
        } else {
            label1.text = "\(team.abilities[0].off)"
            label2.text = "\(team.abilities[1].off)"
            label3.text = "\(team.abilities[2].off)"
            label4.text = "\(team.abilities[0].org)"
            label5.text = "\(team.abilities[1].org)"
            label6.text = "\(team.abilities[2].org)"
            label7.text = "\(team.abilities[0].def)"
            label8.text = "\(team.abilities[1].def)"
            label9.text = "\(team.abilities[2].def)"
        }
    }
}
