import React from 'react';

import { Icon } from '@chakra-ui/react';
import {
  MdBarChart,
  MdPerson,
  MdHome,
  MdLock,
  MdOutlineShoppingCart,
} from 'react-icons/md';

// Admin Imports
import MainDashboard from 'views/admin/default';
import NFTMarketplace from 'views/admin/marketplace';
import Profile from 'views/admin/profile';
import DataTables from 'views/admin/dataTables';
import UserProfileEdit from 'views/admin/editProfile/components/editProfile';
// import RTL from 'views/admin/rtl';
import Users from 'views/admin/users';
// Auth Imports
import SignInCentered from 'views/auth/signIn';
import SignUp from 'views/auth/signUp';

const routes = [
  {
    name: 'Dashboard',
    layout: '/admin',
    path: '/default',
    icon: <Icon as={MdHome} width='20px' height='20px' color='inherit' />,
    component: MainDashboard,
  },
  // {
  //   name: 'NFT Marketplace',
  //   layout: '/admin',
  //   path: '/nft-marketplace',
  //   icon: (
  //     <Icon
  //       as={MdOutlineShoppingCart}
  //       width='20px'
  //       height='20px'
  //       color='inherit'
  //     />
  //   ),
  //   component: NFTMarketplace,
  //   secondary: true,
  // },
  {
    name: 'Transactions',
    layout: '/admin',
    icon: <Icon as={MdBarChart} width='20px' height='20px' color='inherit' />,
    path: '/transactions',
    component: DataTables,
  },
  {
    name: 'Users',
    layout: '/admin',
    icon: <Icon as={MdPerson} width='20px' height='20px' color='inherit' />,
    path: '/users',
    component: Users,
  },
  {
    name: 'Profile',
    layout: '/admin',
    path: '/profile',
    icon: <Icon as={MdPerson} width='20px' height='20px' color='inherit' />,
    component: Profile,
  },
  {
    name: 'Edit Profile',
    layout: '/admin',
    path: '/edit-profile',
    icon: <Icon as={MdPerson} width='20px' height='20px' color='inherit' />,
    component: UserProfileEdit,
  },
  {
    name: 'Sign In',
    layout: '/auth',
    path: '/sign-in',
    icon: <Icon as={MdLock} width='20px' height='20px' color='inherit' />,
    component: SignInCentered,
  },
  {
    name: 'Sign Up',
    layout: '/auth',
    path: '/sign-up',
    icon: <Icon as={MdLock} width='20px' height='20px' color='inherit' />,
    component: SignUp,
  },
];

export default routes;
