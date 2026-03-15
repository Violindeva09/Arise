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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(system),
              const SizedBox(height: 8),
              _buildSpecializationTag(workoutType),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
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
              if (selectedItem != null) 
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: _buildItemDetail(selectedItem, system),
                ),
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
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: AriseUI.glassHUD().copyWith(
        border: Border.all(color: AriseUI.primary.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: AriseUI.primary.withOpacity(0.4)),
              color: Colors.black,
            ),
            child:
                Icon(_getItemIcon(item.type), color: AriseUI.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(item.name.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1)),
                    ),
                    if (canEquip)
                      SizedBox(
                        height: 30,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            side: BorderSide(color: AriseUI.primary, width: 1),
                          ),
                          onPressed: () => isEquipped
                              ? system.unequipItem(item.type)
                              : system.equipItem(item),
                          child: Text(isEquipped ? 'UNEQUIP' : 'EQUIP', 
                            style: const TextStyle(fontSize: 9)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 9,
                        height: 1.2,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 6),
                Text(
                    item.statBoost
                        .toJson()
                        .entries
                        .where((e) => e.value > 0)
                        .map((e) => '+${e.value} ${e.key.toUpperCase()}')
                        .join('  '),
                    style: TextStyle(
                      color: AriseUI.secondary.withOpacity(0.8), 
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    )),
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
