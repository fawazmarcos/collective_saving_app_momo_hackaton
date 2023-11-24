import React from 'react';

import { Icon } from '@chakra-ui/react';
import {
  MdBarChart,
  MdPerson,
  MdHome,
  MdLock,
  MdSavings,
  // MdOutlineShoppingCart,
} from 'react-icons/md';
import { VscGitPullRequestNewChanges } from "react-icons/vsc";
import { BiMoneyWithdraw } from "react-icons/bi";

// Admin Imports
import MainDashboard from 'views/admin/default';
import Souscriptions from 'views/admin/souscriptions';
import TypeEpargnes from 'views/admin/typeEpargnes';
import WithdrawlsRequests from 'views/admin/withdrawlsRequests';
import Subventions from 'views/admin/subventions';

// import NFTMarketplace from 'views/admin/marketplace';
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
    icon: <Icon as={MdHome} width="20px" height="20px" color="inherit" />,
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
    name: 'Utilisateurs',
    layout: '/admin',
    icon: <Icon as={MdPerson} width="20px" height="20px" color="inherit" />,
    path: '/users',
    component: Users,
  },
  {
    name: 'Souscriptions',
    layout: '/admin',
    icon: <Icon as={MdSavings} width="20px" height="20px" color="inherit" />,
    path: '/subscriptions',
    component: Souscriptions,
  },
  {
    name: 'Transactions',
    layout: '/admin',
    icon: <Icon as={MdBarChart} width="20px" height="20px" color="inherit" />,
    path: '/transactions',
    component: DataTables,
  },
  {
    name: 'Demandes de Retraits',
    layout: '/admin',
    icon: <Icon as={BiMoneyWithdraw} width="20px" height="20px" color="inherit" />,
    path: '/withdrawls-request',
    component: WithdrawlsRequests,
  },
  {
    name: 'Demandes de Subventions',
    layout: '/admin',
    icon: <Icon as={VscGitPullRequestNewChanges} width="20px" height="20px" color="inherit" />,
    path: '/subventions',
    component: Subventions,
  },
  {
    name: "Types d'épargne",
    layout: '/admin',
    icon: <Icon as={MdSavings} width="20px" height="20px" color="inherit" />,
    path: '/type-of-saving',
    component: TypeEpargnes,
  },
  {
    name: 'Profile',
    layout: '/admin',
    path: '/profile',
    icon: <Icon as={MdPerson} width="20px" height="20px" color="inherit" />,
    component: Profile,
  },
  {
    name: 'Edit Profile',
    layout: '/profile',
    path: '/edit-profile',
    icon: <Icon as={MdPerson} width="20px" height="20px" color="inherit" />,
    component: UserProfileEdit,
  },
  {
    name: 'Sign In',
    layout: '/auth',
    path: '/sign-in',
    icon: <Icon as={MdLock} width="20px" height="20px" color="inherit" />,
    component: SignInCentered,
  },
  {
    name: 'Sign Up',
    layout: '/auth',
    path: '/sign-up',
    icon: <Icon as={MdLock} width="20px" height="20px" color="inherit" />,
    component: SignUp,
  },
];

export default routes;
