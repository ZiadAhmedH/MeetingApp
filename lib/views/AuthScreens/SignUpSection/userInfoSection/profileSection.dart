
import 'package:flutter/material.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';
import '../../../../model/components/CustomText.dart';
import '../../../../model/components/TextFormFeild.dart';
import '../../../../utils/AppColor.dart';
import '../../../../viewModel/bloc/ProfileCubit/profile_cubit.dart';
import 'AcceptTermsSection.dart';
import 'dropDownSection.dart';
class ProfileInputSection extends StatelessWidget {
  const ProfileInputSection({super.key});

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);
    return  Form(
      key: profileCubit.profileKey,
      child: Column(
        children: [
           Row(
            children: [
              CustomText(
                text: 'Your Profile',
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.normal,
                color: context.thirdTextColor,
                fontSize: 20,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: CustomTextFormField(
                      hintText: "First Name",
                      controller: ProfileCubit.firstName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                      icon: const Icon(
                        Icons.person,
                        color: AppColor.lightBlack,
                      ))),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: CustomTextFormField(
                      hintText: "Last Name",
                      controller: ProfileCubit.lastName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                      icon: const Icon(
                        Icons.person,
                        color: AppColor.lightBlack,
                      ))),
            ],
          ),
          const SizedBox(
            height: 10,
          ),

          const DropDownSection(),

          const SizedBox(
            height: 10,
          ),
          CustomTextFormField(
              hintText: "loading...",
              readOnly: true,
              controller: ProfileCubit.userLocation,
              icon: ProfileCubit.userLocation == null
                  ? const Icon(Icons.question_mark)
                  : const Icon(
                Icons.location_on_outlined,
                color: AppColor.grey,
              )),
          AcceptTerms(
            cubit: profileCubit,
            onTap: () {
              profileCubit.acceptTerms();
            },
            isAcceptTerms: profileCubit.isAcceptTerms,
          ),
        ],
      ),
    );
  }
}
