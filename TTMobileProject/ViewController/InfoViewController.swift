//
//  InfoViewController.swift
//  TTMobileProject
//
//  Created by Mihailo Jovanovic on 13.8.21..
//

import UIKit
import PDFKit

class InfoViewController: UIViewController {

    private var pdfView: PDFView?
    private var pdfDocument: PDFDocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pdfView = PDFView(frame: self.view.bounds)
        self.view.addSubview(pdfView!)
        
            
        pdfView?.autoScales = true
        pdfView?.displayMode = .singlePage
        pdfView?.displayDirection = .vertical
        pdfView?.usePageViewController(true)
            
        guard let path = Bundle.main.url(forResource: "Mihailo Jovanovic 2021", withExtension: "pdf") else {
                print("Unable to locate file")
                return
            }
            
        pdfDocument = PDFDocument(url: path)
        pdfView?.document=pdfDocument
    }

}
