//
//  QRCodeReader.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 12/1/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import SwiftUI
import CodeScanner

struct QRCodeReader: View, Logging {
    var onArtworkResult: (String) -> Void = {_ in }
    var onClose: () -> Void
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            CodeScannerView(codeTypes: [.qr], shouldVibrateOnSuccess: false) { response in
                switch response {
                case .success(let result):
                    onSuccess(result.string)
                case .failure(let error):
                    logger.error("Failed to read QR code: \(error.localizedDescription)")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .overlay {
                Rectangle()
                    .fill(.black.opacity(0.6))
                    .reverseMask {
                        ScannerViewFinder()
                            .blendMode(.destinationOut)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(.white, lineWidth: 3)
                            .frame(width: 275, height: 275, alignment: .center)
                    }
                    .ignoresSafeArea()
            }
            HStack {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .frame(width: 44, height: 44)
                        .foregroundColor(.white)
              }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func onSuccess(_ result: String) {
        if let id = Links.fromDetailLink(result) {
            onArtworkResult(id)
        }
    }
}

struct ScannerViewFinder: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 275, height: 275)
    }
}

fileprivate extension View {
    func reverseMask<Mask: View>(
      alignment: Alignment = .center,
      @ViewBuilder _ mask: () -> Mask
    ) -> some View {
      self.mask {
        Rectangle()
          .overlay(alignment: alignment) {
            mask()
              .blendMode(.destinationOut)
          }
      }
    }
}

struct QRCodeReader_Previews: PreviewProvider {
    static var previews: some View {        
        QRCodeReader(
            onClose: {}
        )
    }
}
