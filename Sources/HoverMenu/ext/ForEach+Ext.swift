import SwiftUI
/**
 * - Abstract: This lets us easily use enumerated on arrays that are not
 *             hashable, for hashable list just use enumerated directly in
 *             the foreach etc
 * - Description: This view iterates over a collection and renders each
 *                element using a provided view builder. It avoids the need
 *                for the collection to be hashable by using the index as the
 *                identifier. This is particularly useful when working with
 *                collections that do not conform to the Hashable protocol.
 * - Note: Avoids the need for hashable, index is used as id
 * - Important: Sometimes this wont work if you dont explitly return a view, we should use viewbuilder somewhere I think, but you can still just do: ForEach(Array(section.rows.enumerated()), id: \.offset) { (_ i: Int, _ item: CellType) in and achive the same
 */
internal struct ForEachElementAndIndex<Data, Content>: View where Data: RandomAccessCollection, Content: View {
   /**
    * The data to iterate over.
    * - Description: The collection of data elements that the
    *                ForEachElementAndIndex view will iterate over to create
    *                views with both the index and the element.
    */
   internal var data: Data
   /**
    * A view builder that takes an index and element of the data collection and returns a view.
    * - Description: A closure that takes the index of an element and the
    *                element itself from the data-collection and returns a
    *                corresponding view. This closure is called for each
    *                element in the collection, providing both the element
    *                and its index to facilitate custom view creation that
    *                may depend on the position of the element within the
    *                collection.
    * - Parameters:
    *   - index: The index of the current element within the collection.
    *   - element: The current element from the data collection.
    */
   internal var content: (Int, Data.Element) -> Content
   /**
    * Initializes a ForEachElementAndIndex instance with the specified data and content.
    * - Description: Creates an instance of ForEachElementAndIndex that can iterate
    *                over a collection and provide both the index and the element to
    *                a view builder. This allows for custom views to be generated for
    *                each item in the collection with awareness of the item's position.
    * - Important: ⚠️️ The @ViewBuilder in the param ensures this works in VStacks etc
    * - Parameters:
    *   - data: The collection to iterate over.
    *   - content: A view builder that takes an index and element of the data collection and returns a view.
    */
   internal init(_ data: Data, @ViewBuilder _ content: @escaping (Int, Data.Element) -> Content) {
      self.data = data
      self.content = content
   }
   /**
    * The body of the view.
    */
   internal var body: some View {
      let array = Array(data.enumerated()) // Convert the collection 'data' to an array of enumerated tuples (index, element)
      // Iterates over the enumerated array with a closure that takes an index and an element as parameters.
      ForEach(array, id: \.offset) { (_ index: Int, _ element: Data.Element) in
         self.content(index, element) // Calls the content view builder with the current index and element as the parameters and returns the view.
      }
   }
}
