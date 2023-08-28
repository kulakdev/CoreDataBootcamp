//
//  ContentView.swift
//  CoreDataBootcamp
//
//  Created by Constantine Kulak on 28.08.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: TaskEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskEntity.name, ascending: false)]) var tasks: FetchedResults<TaskEntity>

    @State var textFieldText: String = ""
    @State var isCreatorOpen: Bool = false
    
    let myColor = Color(#colorLiteral(red: 0.3098039216, green: 0.7607843137, blue: 0.7882352941, alpha: 1))
    var body: some View {
        ScrollView {
            NavigationView {
                
                ZStack {
                    VStack(spacing: 20) {
                        TextField("Create task", text: $textFieldText)
                            .font(.headline)
                            .padding(.leading)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        
                        Button(action: {
                            
                        },
                               label: {
                            Text("Submit")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 55)
                                .background(myColor)
                                .cornerRadius(10)
                        })
                        
                        List {
                            ForEach(tasks) { task in
                                HStack {
                                    Image(systemName: task.completion ? "checkmark.square.fill" : "square")
                                        .foregroundColor(myColor)
                                    
                                    Text(task.name ?? "")
                                        .font(Font.custom("Poppins-Light", size: 14))
                                        .lineLimit(1)
                                    Spacer()
                                    
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(Color.white)
                                .padding(.horizontal, 20.0)
                                .onTapGesture {
                                    task.completion = !task.completion
                                    saveItems()
                                }
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .listStyle(PlainListStyle())
                        
                        HStack {
                            Spacer()
                            Button {
                                isCreatorOpen = !isCreatorOpen
                            } label: {
                                Image(systemName: "plus")
                                    .frame(width: 26, height: 26)
                                    .background(myColor)
                                    .clipShape(Circle())
                                    .foregroundColor(Color.white)
                                    .padding()
                            }
                        }
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = TaskEntity(context: viewContext)
            newItem.name = textFieldText
            saveItems()
            textFieldText = ""
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            guard let index = offsets.first else { return }
            let taskEntity = tasks[index]
            viewContext.delete(taskEntity)
//            offsets.map { tasks[$0] }.forEach(viewContext.delete)
            saveItems()
        }
    }
    
    private func saveItems() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    @ViewBuilder
    func CreateTaskOverlayView(isCreatorOpen: Bool) -> some View {
        ZStack{
            VStack {
                HStack {
                    Text("Create a new task")
                        .font(.title2)
                        .foregroundColor(.black)
                    Spacer()
                    Button {
                        self.isCreatorOpen = !isCreatorOpen
                        textFieldText = ""
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
                .background(Color.white)
                .cornerRadius(20)
                Spacer()
                TextField("Enter the task name", text: $textFieldText)
                    .frame(height: 50)
                    .padding(5)
                    .background(Color.black)
                    .opacity(0.4)
                    .cornerRadius(10)
                HStack {
                    Spacer()
                    Button {} label: {
                        Text("Accept")
                            .padding(7)
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    }
                }
                Spacer()
            }
            .frame(width: 325, height: 150)
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
