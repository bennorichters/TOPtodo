library test_constants;

import 'package:toptodo_data/toptodo_data.dart';

const credentials = Credentials(
  url: 'https://your-environment.topdesk.net',
  loginName: 'a',
  password: 'a',
);

const settings = Settings(
  tdBranchId: 'a',
  tdCallerId: 'a',
  tdCategoryId: 'a',
  tdSubcategoryId: 'a',
  tdDurationId: 'a',
  tdOperatorId: 'a',
);

const branchA = TdBranch(id: 'a', name: 'a');
const branchB = TdBranch(id: 'b', name: 'b');
const branchC = TdBranch(id: 'c', name: 'c');

const currentOperator = TdOperator(
  id: 'a',
  name: 'a',
  avatar: 'R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=', // Black dot
  firstLine: true,
  secondLine: true,
);