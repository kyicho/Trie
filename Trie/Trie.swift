//
//  Trie.swift
//  Trie
//
//  Created by kyi moe cho on 2018-05-15.
//  Copyright © 2018 Zabu. All rights reserved.
//  This code is swift adapation of Tushar Roy - https://github.com/mission-peace/interview/blob/master/src/
//   com/interview/suffixprefix/Trie.java

class Trie {
    
    final private var root: Node
    private var lastSearch: Node
    private var lastSearchIndex: Int
    private var suggestionList:[String]
    
    private class Node {
        
        var children:[Character:Node]
        var completeWord:Bool
        init() {
            children = [:]
            completeWord = false
        }
    };
    
    init() {
        root = Node()
        lastSearch = root
        lastSearchIndex = 0
        suggestionList = []
    }
    
    func insert(word:String) {
        var current = root
        
        for index in word.indices {
            let char = word[index]
            
            var node = current.children[char]
            
            if node == nil {
                node = Node()
                current.children[char] = node
            }
            current = node!
        }
    }
    
  
    
    //input : t
    // tar, tall, tent, toy,
    //Assume it's a string not char
    //Use greedy approach. only return complete word
    //Need to keep track of where I left off
    /*func suggestion(_ target:String) -> Bool {
        let current = root
        
        let char = target.last!
        
        if let n = current.children[char] {
            // Keeping tacking of current position
            lastSearchIndex = lastSearchIndex + 1
            lastSearch = n
            
            var str = ""
            let shouldStoreChar = traverse(n)
            
            if shouldStoreChar {
                str += String(char)
            }
            
            
            return true
        }
        
        return false
        
        
    }*/
    
    // In progres
    private func traverse(_ target:String) -> Bool {
        
        var word:String = target
        var childrenQueue:[Node] = []
        var lastNode:Node
        
        var current = root
        var found:Bool = false
        
        
        for char in target {
            
            guard let node =  current.children[char] else {
                break
            }
            current = node
            found = true
        }
        
        if !found {
            return false
        }
        
        
        repeat {
            //Check childre.values == 0
            
            if current.children.values.count == 0 {
                
                if current.completeWord {
                    suggestionList.append(word)
                    word = target
                }
                
            } else {
                childrenQueue.append(contentsOf: current.children.values) // O(n)
                
            }
           
            let last = childrenQueue.last
            
            if last == nil {
                continue
            }
            
            current = last! //O(n)
            
            if current.completeWord {
                
            } else {
                word += String()
            }
            
            
            
            
            
        } while !childrenQueue.isEmpty
        
        return false
        
        
    }
    
    func search(word:String) -> Bool {
        var current = root
        
        for index in word.indices {
            
            let char = word[index]
            
            guard let node =  current.children[char] else {
                return false
            }
            
            current = node
            
        }
        
        return current.completeWord
    }
    
    func delete(word:String) -> Bool {
        return delete(current: root, target: word, intIndex:0)
    }
    
    private func delete(current:Node, target:String, intIndex:Int) -> Bool {
        
        if intIndex == target.count {
            // If it's not a complete word, don't delete the character
            if !current.completeWord {
                return false
            }
            
            // Otherwise, set it to incomplete word
            current.completeWord = false
            
            // If it doesn't have children, delete it
            // Otherwise, don't
            return (current.children.count == 0)
        }
        
        let i = target.index(target.startIndex, offsetBy: intIndex)
        
        if current.children[target[i]] == nil {
            return false
        }
        
        // Set the pointer to the next character
        let node = current.children[target[i]]!
        
        // Pass the next character back to the function and increase the integer index
        let shouldDelete = delete(current: node, target: target, intIndex: (intIndex+1))
        
        if shouldDelete {
            // This is not an efficient way to remove key/value pair since it takes O(n).
            // This will result in time complexity of l(n+k) where l = average length of word,
            // n = total number of words, k = average number of children each node has
            // Think about reimplementing it if you anticipate to store a larger set of data
            current.children.removeValue(forKey: target[i])
            
            return (current.children.count == 0)
        }
        
        return false
        
        
    }
    
}
