import 'package:flutter/material.dart';
import 'package:flutty_heroicons/flutty_heroicons.dart';
import 'package:simple_icons/simple_icons.dart';

class AppIcons {
  // Navigation
  static final IconData dashboard = HeroIcons.squares2x2.outline;
  static final IconData history = HeroIcons.clock.outline;
  static final IconData projects = HeroIcons.folderOpen.outline;
  static final IconData settings = HeroIcons.cog6Tooth.outline;
  static final IconData profile = HeroIcons.user.outline;
  static final IconData brand = HeroIcons.commandLine.solid;

  // Actions
  static final IconData add = HeroIcons.plus.solid;
  static final IconData edit = HeroIcons.pencilSquare.outline;
  static final IconData delete = HeroIcons.trash.outline;
  static final IconData search = HeroIcons.magnifyingGlass.outline;
  static final IconData filter = HeroIcons.funnel.outline;
  static final IconData refresh = HeroIcons.arrowPath.outline;

  // Feedback
  static final IconData success = HeroIcons.checkCircle.outline;
  static final IconData error = HeroIcons.exclamationCircle.outline;
  static final IconData info = HeroIcons.informationCircle.outline;
  static final IconData warning = HeroIcons.exclamationTriangle.outline;
  static final IconData emptyState = HeroIcons.squares2x2.solid;

  // Auth
  static final IconData login = HeroIcons.arrowRightOnRectangle.outline;
  static final IconData logout = HeroIcons.arrowLeftOnRectangle.outline;
  static final IconData visibility = HeroIcons.eye.outline;
  static final IconData visibilityOff = HeroIcons.eyeSlash.outline;
  static final IconData close = HeroIcons.xMark.outline;
  static final IconData personAdd = HeroIcons.userPlus.outline;
  static final IconData link = HeroIcons.link.outline;
  static final IconData chevronDown = HeroIcons.chevronDown.outline;
  static final IconData chevronUp = HeroIcons.chevronUp.outline;
  static final IconData back = HeroIcons.arrowLeft.outline;
  static final IconData providers = HeroIcons.server.outline;
  static final IconData at = HeroIcons.atSymbol.outline;
  static final IconData email = HeroIcons.envelope.outline;
  static final IconData lock = HeroIcons.lockClosed.outline;
  static final IconData unlock = HeroIcons.lockOpen.outline;
  static final IconData building = HeroIcons.buildingOffice.outline;

  // Activity Types
  static final IconData commit = HeroIcons.commandLine.outline;
  static final IconData revision = HeroIcons.codeBracket.outline;
  static final IconData task = HeroIcons.clipboardDocumentCheck.outline;
  static final IconData message = HeroIcons.chatBubbleLeftRight.outline;
  static final IconData genericActivity = HeroIcons.bolt.outline;

  // Providers
  static final IconData github = SimpleIcons.github;
  static final IconData gitlab = SimpleIcons.gitlab;
  static final IconData bitbucket = SimpleIcons.bitbucket;
  static final IconData phorge = HeroIcons.codeBracket.outline;
  static final IconData linear = SimpleIcons.linear;
  static final IconData figma = SimpleIcons.figma;
  static final IconData jira = SimpleIcons.jira;
  /// Slack is no longer in Simple Icons (trademark removal); hashtag is the stand-in.
  static final IconData slack = HeroIcons.hashtag.outline;
  static final IconData discord = SimpleIcons.discord;
  static final IconData unknownProvider = HeroIcons.questionMarkCircle.outline;
  static final IconData testConnection = HeroIcons.bolt.outline;

  // Utility
  static final IconData chevronRight = HeroIcons.chevronRight.outline;
  static final IconData chatMessage = message;
  static final IconData users = HeroIcons.userGroup.outline;
  static final IconData user = HeroIcons.user.outline;
  static final IconData selected = HeroIcons.checkCircle.solid;
  static final IconData follow = HeroIcons.bookmark.outline;
  static final IconData following = HeroIcons.bookmark.solid;
  static final IconData openExternal = HeroIcons.arrowTopRightOnSquare.outline;
  static final IconData calendar = HeroIcons.calendarDays.outline;
  static final IconData insights = HeroIcons.chartBar.outline;
  static final IconData reports = HeroIcons.documentText.outline;
  static final IconData admin = HeroIcons.shieldCheck.outline;
}
