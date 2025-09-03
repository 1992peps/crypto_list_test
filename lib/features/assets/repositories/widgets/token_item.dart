import 'package:flutter/material.dart';
import '../../../../core/utils/color_fabric.dart';
import '../../../../core/utils/currency.dart';
import '../../data/models/token.dart';

class TokenItem extends StatelessWidget {
  const TokenItem({super.key, required this.token, required this.index});

  final Token token;
  final int index;

  @override
  Widget build(BuildContext context) {
    final color = pastelForIndex(index);
    const textStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      height: 24 / 17,
      color: Color(0xFF17171A),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              token.symbol.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
          ),
          Text(formatUsd(token.priceUsd), style: textStyle),
        ],
      ),
    );
  }
}
