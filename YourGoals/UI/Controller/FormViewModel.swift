//
//  EditTaskFormViewModel.swift
//  YourGoals
//
//  Created by André Claaßen on 10.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class FormItem {
    var tag:String
    
    init(tag:String) {
        self.tag = tag
    }
}

class TypedFormItem<T>:FormItem {
    let value:T
    let options:[T]
    
    init(tag:String, value:T) {
        self.value = value
        self.options = []
        super.init(tag: tag)
    }
    
    init(tag:String, value:T, options:[T]) {
        self.value = value
        self.options = options
        super.init(tag: tag)
    }
}


/// a value for the form field
class  TextFormItem : TypedFormItem<String?> {
}

class OptionFormItem<T>:TypedFormItem<T> {
    let valueToText:(T) -> String
    
    init(tag: String, value: T, options:[T], valueToText:@escaping (T) -> String) {
        self.valueToText = valueToText
        super.init(tag: tag, value: value, options: options)
    }
}

/// this class return all form value entries for the the edit task form object
class FormViewModel {
    private var formItems = [FormItem]()
    
    /// add a new item to the form view model
    ///
    /// - Parameter item: the item
    func add(item: FormItem) {
        formItems.append(item)
    }
    
    /// acces to an actionable via the edit task form tag
    ///
    /// - Parameter tag: the tab
    /// - Returns: a typed form item
    func item<T>(tag: String?) -> TypedFormItem<T> {
        guard let tag = tag else {
            fatalError("tag isn't available")
        }
        
        guard let item = self.formItems.first(where: {$0.tag == tag}) else {
            fatalError("the tag \(tag) isn't available for this form")
        }
        
        guard let typedItem = item as? TypedFormItem<T> else {
            fatalError("item with type \(T.self) is for \(tag) not available")
        }
        
        return typedItem
    }
}
