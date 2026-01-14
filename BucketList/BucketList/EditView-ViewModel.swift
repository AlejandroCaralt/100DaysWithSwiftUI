//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Alejandro Caralt on 14/1/26.
//

import Foundation
import Observation

extension EditView {
    @Observable
    class ViewModel {
        enum LoadingState {
            case loading, loaded, failed
        }
        
        var name: String = ""
        var description: String = ""
        var loadingState = LoadingState.loading
        var pages = [Page]()
    }
}
