//
//  UploadView.swift
//  Concurrency
//
//  Created by Rita Marrano on 30/03/23.
//

import SwiftUI
import FirebaseStorage

struct UploadView: View {
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    var data = FirebaseImageLoader(path: "images/")
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            } else {
                Text("No image selected")
                    .foregroundColor(.gray)
            }
            Button("Select Image") {
                isImagePickerPresented = true
            }
            .padding()
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
            }
            Button("Upload Image") {
                guard let image = selectedImage else { return }
                data.uploadImageToFirebaseStorage(image: image) { (imageUrl, error) in
                    if let error = error {
                        print("Error uploading image: \(error.localizedDescription)")
                    } else {
                        print("Image uploaded successfully with URL: \(imageUrl ?? "")")
                    }
                }
            }
            .padding()
        }
    }

//    func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (String?, Error?) -> ()) {
//        let storageRef = Storage.storage().reference().child("images/")
//        let imageName = "\(UUID().uuidString).jpg"
//        let imageRef = storageRef.child(imageName)
//
//        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
//            completion(nil, NSError(domain: "Invalid image data", code: 0, userInfo: nil))
//            return
//        }
//
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//
//        imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
//            if let error = error {
//                completion(nil, error)
//            } else {
//                imageRef.downloadURL { (url, error) in
//                    guard let url = url else {
//                        completion(nil, error)
//                        return
//                    }
//                    completion(url.absoluteString, nil)
//                }
//            }
//        }
//    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
