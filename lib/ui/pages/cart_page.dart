import 'package:epsi_shop/bo/cart.dart';
import 'package:epsi_shop/bo/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();
    final items = cart.listProducts;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('EPSI Shop'),
      ),
      body: Column(
        children: [
          if (items.isNotEmpty) TotalCart(cart: cart),
          Expanded(
            child: items.isEmpty
                ? const EmptyCartMessage()
                : CartItemList(items: items),
          ),
          if (items.isNotEmpty) const CheckoutButton(),
        ],
      ),
    );
  }
}

class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CartAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text('EPSI Shop'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class TotalCart extends StatelessWidget {
  final Cart cart;

  const TotalCart({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total TTC", style: Theme.of(context).textTheme.titleLarge),
          Text("${cart.getTotalTTC().toStringAsFixed(2)}€",
              style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

class EmptyCartMessage extends StatelessWidget {
  const EmptyCartMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Votre panier est vide.",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class CartItemList extends StatelessWidget {
  final List<Product> items;

  const CartItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        final item = items[index];
        return Consumer<Cart>(
          builder: (context, cart, child) =>
              CartItem(product: item, cart: cart),
        );
      },
    );
  }
}

class CartItem extends StatelessWidget {
  final Product product;
  final Cart cart;

  const CartItem({super.key, required this.product, required this.cart});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(product.image,
          width: 60, height: 60, fit: BoxFit.cover),
      title: Text(product.title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(product.getPrice(),
          style: Theme.of(context).textTheme.bodyMedium),
      trailing: TextButton(
        onPressed: () => cart.removeProduct(product),
        child: Text("SUPPRIMER",
            style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ),
    );
  }
}

class CheckoutButton extends StatelessWidget {
  const CheckoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20.0),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Paiement en cours...")),
            );
          },
          child: const Text(
            "Procéder au paiement",
          ),
        ),
      ),
    );
  }
}
