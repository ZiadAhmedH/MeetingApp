import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/AppColor.dart';
import '../../../../viewModel/bloc/ProfileCubit/profile_cubit.dart';
class DropDownSection extends StatelessWidget {


  const DropDownSection({super.key});
  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);

    return   BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: AppColor.lightBlack,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: AppColor.grey , width: 1.0),
          ),
          child: DropdownButton(
            alignment: Alignment.bottomCenter,
            underline: Container(),
            items: profileCubit.
            jobTitle
                .map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: AppColor.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Text(
                    value,
                    style: const TextStyle(color: AppColor.white , fontSize: 16.0, fontWeight: FontWeight.normal, fontFamily: 'Gilroy'),
                  ),
                )
              );
            }).toList(),
            onChanged: (value) {
              profileCubit.changingJobTitle(value!);
            },
            value: ProfileCubit.currentStatus,
            style: const TextStyle(color: AppColor.white),
            isExpanded: true,
            borderRadius: BorderRadius.circular(8.0),
            dropdownColor: AppColor.lightBlack,

          ),
        );
      },
    );

  }
}
