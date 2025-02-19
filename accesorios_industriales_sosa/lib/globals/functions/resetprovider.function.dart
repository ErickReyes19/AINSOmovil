
import 'package:provider/provider.dart';

import '../../providers/providers.dart';


resetProviders(context) {
  Provider.of<AuthProvider>(context, listen: false).resetProvider();
}
