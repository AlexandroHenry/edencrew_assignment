import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';

const _keyName = 'my_profile_name';
const _keyInvestmentType = 'my_profile_investment_type';

class SharedPreferencesUserProfileRepository implements UserProfileRepository {
  const SharedPreferencesUserProfileRepository(this._prefs);

  // SharedPreferences? 허용: prefs가 null이면 기본값을 반환하고 저장은 no-op 처리
  final SharedPreferences? _prefs;

  @override
  Future<UserProfile> load() async {
    final name = _prefs?.getString(_keyName);
    final typeIndex = _prefs?.getInt(_keyInvestmentType);
    return UserProfile(
      name: name ?? '투자자',
      investmentType: typeIndex != null
          ? InvestmentType.values[typeIndex]
          : InvestmentType.moderate,
    );
  }

  @override
  Future<void> save(UserProfile profile) async {
    await _prefs?.setString(_keyName, profile.name);
    await _prefs?.setInt(_keyInvestmentType, profile.investmentType.index);
  }
}
