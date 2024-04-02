//
//  AnnotationView.swift
//  MapKitiOS17SwiftUI
//
//  Created by Oleksandr Isaiev on 02.04.2024.
//

import SwiftUI

struct AnnotationView: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 32, height: 32)
                .foregroundStyle(.indigo.opacity(0.25))
            Circle()
                .frame(width: 20, height: 20)
                .foregroundStyle(.white)
            Circle()
                .frame(width: 12, height: 12)
                .foregroundStyle(.indigo)
        }
    }
}

#Preview {
    AnnotationView()
}
