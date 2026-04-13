import 'package:modelhandling/model/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class ProductController {
  final supabase = Supabase.instance.client;
  // Get all Product
  Future<List<Product>> getProduct() async {
    final data = await supabase.from('products').select();
    return data.map((item) => Product.fromMap(item)).toList();
  }

  // Add Product
  Future<void> addProduct(Product product) async {
    await supabase.from('products').insert(product.toMap());
  }

  // Delete Product
  Future<void> deleteProduct(int id) async {
    await supabase.from('products').delete().eq('id', id);
  }

  //Calculate grand Total
  double calculateGrandTotal(List<Product> products){
    double total = 0;
    for (var product in products){
      total += product.price * product.quantity;
    }
    return total;
  }

   // Count total item
  int countTotalItem(List<Product> products){
    int count = 0;
    for (var products in products) {
      count += products.quantity;
    }
    return count;
  }
}