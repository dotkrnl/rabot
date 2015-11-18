from progress.models import ProgressDao


class ArchiveManger():

    def __init__(self):
        self.dao = ProgressDao()

    def clear(self):
        all_progress = self.dao.get_all_progess()
        for progress in all_progress:
            self.dao.delete_progress(progress)

    def add_progress(self, uid, info):
        if self.dao.user_is_valid(uid):
            if self.dao.get_progress_by_uid(uid):
                return 'User #%s\'s progress already exists.' % (str(uid))
            else:
                self.dao.create_progress(uid, info)
                return 'Succeeded.'
        else:
            return 'Uid is invalid.'

    def update_progress(self, uid, new_info):
        cur_progress = self.dao.get_progress_by_uid(uid)
        if cur_progress:
            if len(new_info) > 0:
                self.dao.update_progress_info(cur_progress, new_info)
            return 'Succeeded.'
        else:
            return 'User #%s\'s progress does not exist' % (str(uid))

    def delete_progress(self, uid):
        cur_progress = self.dao.get_progress_by_uid(uid)
        if cur_progress:
            self.dao.delete_progress(cur_progress)
            return 'Succeeded.'
        else:
            return 'Succeeded, nothing is done.'

    def search_progress(self, uid):
        cur_progress = self.dao.get_progress_by_uid(uid)
        if cur_progress:
            return [cur_progress]
        else:
            return []
