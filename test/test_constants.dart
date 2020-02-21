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

const categoryA = TdCategory(id: 'a', name: 'a');
const categoryB = TdCategory(id: 'b', name: 'b');
const categoryC = TdCategory(id: 'c', name: 'c');

const durationA = TdDuration(id: 'a', name: 'a');
const durationB = TdDuration(id: 'b', name: 'b');
const durationC = TdDuration(id: 'c', name: 'c');

const currentOperator = TdOperator(
  id: 'a',
  name: 'a',
  avatar: 'R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=', // Black dot
  firstLine: true,
  secondLine: true,
);
