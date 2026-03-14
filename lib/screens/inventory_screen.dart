import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/system_provider.dart';
import '../models/item.dart';
import '../config/ui_config.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  int? _selectedSlot;

  @override
  Widget build(BuildContext context) {
    final system = Provider.of<SystemProvider>(context);
    final workoutType = system.stats.workoutType;
    final items = system.inventory;

    final selectedItem =
        (_selectedSlot != null && _selectedSlot! < items.length)
            ? items[_selectedSlot!]
            : (items.isNotEmpty ? items.first : null);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(system),
              const SizedBox(height: 12),
              _buildSpecializationTag(workoutType),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 36,
                  itemBuilder: (context, index) {
                    final item = index < items.length ? items[index] : null;
                    return _buildSlot(index, item, system);
                  },
                ),
              ),
              if (selectedItem != null) _buildItemDetail(selectedItem, system),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(SystemProvider system) {
    final eq = system.equippedItems;
    return Row(
      children: [
        AriseUI.ornament(),
        const SizedBox(width: 12),
        Text("03 INVENTORY", style: AriseUI.heading),
        const Spacer(),
        Text(
          'W:${eq[ItemType.weapon]?.name ?? '-'} A:${eq[ItemType.armor]?.name ?? '-'} X:${eq[ItemType.accessory]?.name ?? '-'}',
          style: const TextStyle(color: Colors.white54, fontSize: 8),
        )
      ],
    );
  }

  Widget _buildSpecializationTag(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: AriseUI.glassHUD().copyWith(
        border: Border.all(color: AriseUI.primary.withOpacity(0.3)),
        color: AriseUI.primary.withOpacity(0.05),
      ),
      child: Text("SPECIALIZATION: $type",
          style: TextStyle(
              color: AriseUI.primary,
              fontSize: 8,
              fontWeight: FontWeight.bold,
              letterSpacing: 1)),
    );
  }

  Widget _buildSlot(int index, Item? item, SystemProvider system) {
    bool isSelected = _selectedSlot == index ||
        (_selectedSlot == null && index == 0 && item != null);

    return GestureDetector(
      onTap: () {
        if (item != null) {
          setState(() => _selectedSlot = index);
        }
      },
      child: Container(
        decoration: AriseUI.glassHUD().copyWith(
          color: item == null
              ? Colors.black.withOpacity(0.3)
              : AriseUI.primary.withOpacity(0.05),
          border: Border.all(
            color: isSelected
                ? AriseUI.primary
                : (item == null
                    ? Colors.white.withOpacity(0.05)
                    : AriseUI.primary.withOpacity(0.2)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: item == null
            ? null
            : Stack(
                children: [
                  Center(
                    child: Icon(_getItemIcon(item.type),
                        color: AriseUI.primary, size: 20),
                  ),
                  if (system.isEquipped(item))
                    const Positioned(
                      top: 2,
                      right: 2,
                      child: Icon(Icons.check_circle,
                          color: Colors.lightGreenAccent, size: 12),
                    ),
                ],
              ),
      ),
    );
  }

  Widget _buildItemDetail(Item item, SystemProvider system) {
    final canEquip = item.type == ItemType.weapon ||
        item.type == ItemType.armor ||
        item.type == ItemType.accessory;
    final isEquipped = system.isEquipped(item);

    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(20),
      decoration: AriseUI.glassHUD(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AriseUI.primary.withOpacity(0.5)),
              color: Colors.black,
            ),
            child:
                Icon(_getItemIcon(item.type), color: AriseUI.primary, size: 40),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.name.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1)),
                    if (canEquip)
                      OutlinedButton(
                        onPressed: () => isEquipped
                            ? system.unequipItem(item.type)
                            : system.equipItem(item),
                        child: Text(isEquipped ? 'UNEQUIP' : 'EQUIP'),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(item.description,
                    style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        height: 1.5,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 8),
                Text(
                    item.statBoost
                        .toJson()
                        .entries
                        .where((e) => e.value > 0)
                        .map((e) => '+${e.value} ${e.key.toUpperCase()}')
                        .join('  '),
                    style: const TextStyle(color: Colors.white70, fontSize: 9)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getItemIcon(ItemType type) {
    switch (type) {
      case ItemType.weapon:
        return Icons.bolt;
      case ItemType.armor:
        return Icons.shield;
      case ItemType.accessory:
        return Icons.fitness_center;
      case ItemType.consumable:
        return Icons.local_pharmacy_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}
