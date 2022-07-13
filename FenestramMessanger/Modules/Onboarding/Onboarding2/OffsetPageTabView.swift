//
//  OffsetPageTabView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 12.07.2022.
//

import SwiftUI

struct OffsetPageTabView<Content: View>: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return OffsetPageTabView.Coordinator(parent: self)
    }
    
    
    var content: Content
    @Binding var offset: CGFloat
   
    init(offset: Binding<CGFloat>, @ViewBuilder content: @escaping ()->Content)
    {
        self.content = content()
        self._offset = offset 
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        //scrollView.translatesAutoresizingMaskIntoConstraints = false
        let hostView = UIHostingController(rootView: content)
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            hostView.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostView.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            hostView.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ]
        scrollView.addSubview(hostView.view)
        scrollView.addConstraints(constraints)
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator
        
        return scrollView
    }
    
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        let currentOffset = uiView.contentOffset.x
        if currentOffset != offset {
            uiView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            print("gggg")
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: OffsetPageTabView
        init(parent: OffsetPageTabView){
            self.parent = parent
        }
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.x
            parent.offset = offset
        }
    }
    
}

struct OffsetPageTabView_Previews: PreviewProvider {
    static var previews: some View {
        ContentOnboarding()
    }
}
