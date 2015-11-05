from archive.models import ArchiveDao


class ArchiveManger():

    def __init__(self):
        self.dao = ArchiveDao()

    def clear(self):
        all_archive = self.dao.get_all_archive()
        for archive in all_archive:
            self.dao.delete_archive(archive)

    def save(self, uid, sid, info):
        if self.dao.user_and_stage_is_valid(uid, sid):
            target = self.dao.get_archive_by_uid_and_sid(uid, sid)
            if target:
                self.dao.update_archive_info(target, info)
                return 'Succeeded. Updated archive #' + str(target.arid)
            else:
                all_archive = self.dao.get_all_archive()
                if len(all_archive) > 0:
                    arid = all_archive[-1].arid + 1
                else:
                    arid = 1

                self.dao.create_archive(arid, uid, sid, info)
                return 'Succeeded. New archive #' + str(arid)
        else:
            return 'Uid or sid is invalid.'

    def load(self, uid, sid):
        if self.dao.user_and_stage_is_valid(uid, sid):
            target = self.dao.get_archive_by_uid_and_sid(uid, sid)
            if target:
                return target
            else:
                return None
        else:
            return None
