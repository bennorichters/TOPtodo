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

const _blackDot = 'R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=';

const branchA = TdBranch(id: 'a', name: 'a');
const branchB = TdBranch(id: 'b', name: 'b');
const branchC = TdBranch(id: 'c', name: 'c');

const callerA = TdCaller(
  id: 'c',
  name: 'c',
  branch: branchA,
  avatar: _blackDot,
);

const categoryA = TdCategory(id: 'a', name: 'a');
const categoryB = TdCategory(id: 'b', name: 'b');
const categoryC = TdCategory(id: 'c', name: 'c');

const subcategoryA = TdSubcategory(id: 'c', name: 'c', category: categoryA);

const durationA = TdDuration(id: 'a', name: 'a');
const durationB = TdDuration(id: 'b', name: 'b');
const durationC = TdDuration(id: 'c', name: 'c');

const currentOperator = TdOperator(
  id: 'a',
  name: 'a',
  avatar: _blackDot,
  firstLine: true,
  secondLine: true,
);
